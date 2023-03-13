# pingcheck

const month31 = [1, 3, 5, 7, 8, 10, 12]
const month30 = [4, 6, 9, 11]
const month28 = 2

# サーバーの故障を検出し、故障しているサーバーとその故障期間を返すプログラム
function pingcheck(file_name, N=1, m=0, t=Inf)
    open(file_name, "r") do f
        # println(N, m, t)
        # 故障が確認されたサーバーのデータを辞書に格納する
        # キーはサーバーアドレス、値は(確認日時, タイムアウトの連続回数)とする
        # 直ったサーバーの情報は削除する
        er = Dict()
        
        # 応答時間を記録していく
        # キーはサーバーアドレス、値は[(確認日時, 応答時間)]とする
        d = Dict()

        # サブネットを記録していく
        # キーはサブネット、値は[同一サブネット内のサーバーアドレス]
        sub = Dict()

        # 故障が直ったサーバーのデータを格納する
        # キーはサーバーアドレス、値は[(故障の確認日時, 修復の確認日時, タイムアウトの連続回数)]とする
        fix = Dict()

        # for debug
        readl = 0

        for line in eachline(f)
            #readl += 1
            # ping応答の確認結果はカンマ区切りの3要素なので分割
            l = split(line, ',')

            ## 過負荷関係エリア1
            if !haskey(d, l[2])
                d[l[2]] = []
            end

            d_ = d[l[2]]
            if l[3] != "-"
                push!(d_, (l[1], parse(Int, l[3])))
            end
            d[l[2]] = d_
            ## 1ここまで

            ## サブネット関係
            if !haskey(sub, l[2][begin:end-4])
                sub[l[2][begin:end-4]] = [l[2]]
            else
                ls = sub[l[2][begin:end-4]]
                !(l[2] in ls) && push!(ls, l[2])
                sub[l[2][begin:end-4]] = ls
            end
            ## サブネットここまで

            if l[3] == "-"
                if !(haskey(er, l[2]))
                    er[l[2]] = (l[1], 1)
                elseif haskey(er, l[2])
                    pt, count = er[l[2]][1], er[l[2]][2]
                    er[l[2]] = (pt, count+1)
                end
            else
                if haskey(er, l[2]) 
                    if er[l[2]][2] >= N
                        #Y1,M1,D1,h1,m1,s1 = ymdhms(er[l[2]][1])
                        #Y2,M2,D2,h2,m2,s2 = ymdhms(l[1])
                        #println("サーバーアドレス：", l[2], " 故障期間：",  Y1, "年", M1, "月", D1, "日", h1, "時", m1, "分", s1, "秒 ～ ", Y2, "年", M2, "月", D2, "日", h2, "時", m2, "分", s2, "秒")
                        if !haskey(fix, l[2])
                            fix[l[2]] = [(er[l[2]][1], l[1], er[l[2]][2])]
                        else
                            lsf = fix[l[2]]
                            push!(lsf, (er[l[2]][1], l[1], er[l[2]][2]))
                            fix[l[2]] = lsf
                        end
                        delete!(er, l[2])
                    else
                        delete!(er, l[2])
                    end
                end
            end
        end

        # 故障関係
        suber = suberr(er, fix, sub)
        for sn in keys(fix), si in fix[sn]
            Y1,M1,D1,h1,m1,s1 = ymdhms(si[1])
            Y2,M2,D2,h2,m2,s2 = ymdhms(si[2])
            println("サーバーアドレス：", sn, ", 故障期間：",  Y1, "年", M1, "月", D1, "日", h1, "時", m1, "分", s1, "秒 ～ ", Y2, "年", M2, "月", D2, "日", h2, "時", m2, "分", s2, "秒")
        end

        for sb in keys(suber), serr in suber[sb]
            Y1,M1,D1,h1,m1,s1 = ymdhms(serr[1])
            Y2,M2,D2,h2,m2,s2 = ymdhms(serr[2])
            println("サブネット：", sb, ", 故障期間：",  Y1, "年", M1, "月", D1, "日", h1, "時", m1, "分", s1, "秒 ～ ", Y2, "年", M2, "月", D2, "日", h2, "時", m2, "分", s2, "秒")
        end

        err_s = Dict()
        err_sub = Dict()
        if !isempty(er)
            err_1 = 0
            err_2 = 0
            for k in keys(er)
                if er[k][2] >= N
                    err_1 = 1
                    err_s[k] = er[k][1]         
                end
            end

            if !isempty(err_s)
                for k_sub in keys(sub)
                    if all([(s in keys(err_s)) for s in sub[k_sub]])
                        err_2 = 1
                        err_sub[k_sub] = string(maximum([parse(Int, err_s[k]) for k in keys(err_s)]))
                    end
                end
            end

            if err_1 == 1
                println("故障中のサーバー")
                for k in keys(err_s)
                    Y1,M1,D1,h1,m1,s1 = ymdhms(err_s[k])
                    println("サーバーアドレス：", k, ", 故障期間：",  Y1, "年", M1, "月", D1, "日", h1, "時", m1, "分", s1, "秒 ～ ")            
                end
            end
            
            if err_2 == 1
                println("故障中のサブネット")
                for k_sub in keys(err_sub)
                    Y1,M1,D1,h1,m1,s1 = ymdhms(err_sub[k_sub])
                    println("サブネット：", k_sub, ", 故障期間：",  Y1, "年", M1, "月", D1, "日", h1, "時", m1, "分", s1, "秒 ～ ")            
                end
            end
        end

        ## 過負荷関係2
        if !isempty(d)
            over = Dict()
            for k in keys(d)
                dd = d[k]
                sum = 0

                if length(dd) < m && length(dd) > 0 
                    for i in length(dd)
                        sum += dd[i][2]
                    end

                    if (sum / length(dd)) >= t
                        !haskey(over, k) && (over[k] = [(dd[1][1], dd[end][1])])
                    end 
                else
                    for j in 1:length(dd)-(m-1)
                        for i in 0:(m-1)
                            sum += dd[j+i][2]
                        end

                        if (sum / m) >= t
                            if !haskey(over, k)
                                over[k] = [(dd[j][1], dd[j+m-1][1])]
                            else
                                l_over = over[k]
                                for k_over in l_over
                                    if parse(Int, k_over[1]) >= parse(Int, dd[j][1]) && parse(Int, k_over[2]) <= parse(Int, dd[j+m-1][1])
                                        setdiff!(l_over, [k_over])
                                        push!(l_over, (dd[j][1], dd[j+m-1][1]))
                                    elseif parse(Int, k_over[2]) >= parse(Int, dd[j][1])
                                        setdiff!(l_over, [k_over])
                                        push!(l_over, (k_over[1], dd[j+m-1][1]))
                                    elseif parse(Int, k_over[1]) <= parse(Int, dd[j+m-1][1])
                                        setdiff!(l_over, [k_over])
                                        push!(l_over, (dd[j][1], k_over[2]))
                                    else
                                        push!(l_over, (dd[j][1], dd[j+m-1][1]))
                                    end
                                end
                                over[k] = l_over
                            end
                        end
                    end
                end
            end
        end
        
        if !isempty(over)
            println("過負荷だったサーバー")
            for ko in keys(over), o in over[ko]
                Y1,M1,D1,h1,m1,s1 = ymdhms(o[1])
                Y2,M2,D2,h2,m2,s2 = ymdhms(o[2])
                println("サーバーアドレス：", ko, ", 過負荷期間：",  Y1, "年", M1, "月", D1, "日", h1, "時", m1, "分", s1, "秒 ～ ", Y2, "年", M2, "月", D2, "日", h2, "時", m2, "分", s2, "秒")
            end
        end
        ## 2ここまで
    end
end

# ping応答の確認日時の形式をYYYYMMDDhhmmssから(YYYY, MM, DD, hh, mm, ss)に変換する関数
# YYYYMMDDhhmmssの形式は文字列の形式が固定なのでそのまま分解する
function ymdhms(s) 
    YYYY = parse(Int, s[begin:4])
    #deleteat!(s, 1:4)
    MM = parse(Int, s[5:6])
    #deleteat!(s, 1:2)
    DD = parse(Int, s[7:8])
    #deleteat!(s, 1:2)
    hh = parse(Int, s[9:10])
    #deleteat!(s, 1:2)
    mm = parse(Int, s[11:12])
    #deleteat!(s, 1:2)
    ss = parse(Int, s[13:14])
    #deleteat!(s, 1:2)

    return YYYY, MM, DD, hh, mm, ss
end

#= 故障期間の計算をする関数
function cul_ping(ymdhms_1, ymdhms_2)
    ymdhms1 = reverse(ymdhms_1)
    ymdhms2 = reverse(ymdhms_2)
    down = 0    # 繰り下がり

    s, down = cul60(ymdhms1[1], ymdhms2[1], down)
    m, down = cul60(ymdhms1[2], ymdhms2[2], down)
    h, down = cul24(ymdhms1[3], ymdhms2[3], down)
    Y, M, D = culyear_month_day(ymdhms1[6], ymdhms1[5], ymdhms1[4], ymdhms2[6], ymdhms2[5], ymdhms2[4], down)

    return (Y, M, D, h, m, s)
end

# 分、秒の計算
function cul60(a, b, down)
    c = 0
    down_ = 0
    if a-down < b
        c = (60+a-down) - b
        down_ = 1
    else
        c = (a-down) - b
    end

    return c, down_
end

# 時間計算
function cul24(a, b, down)
    c = 0
    down_ = 0
    if a-down < b
        c = (24+a-down) - b
        down_ = 1
    else
        c = (a-down) - b
    end

    return c, down_
end

# 年数、月数、日数の計算
function culyear_month_day(a_y, a_m, a_d, b_y, b_m, b_d, down)
    c_y = 0
    c_m = 0
    c_d = 0

    down_ = down

    # 日数計算
    if a_d-down < b_d
        if a_m in month31 
            c_d = (31+a_d-down_) - b_d
        elseif a_m in month30
            c_d = (30+a_d-down_) - b_d
        elseif a_m == month28
            if b_y % 4 == 0
                c_d = (29+a_d-down_) - b_d
            else
                c_d = (28+a_d-down_) - b_d
            end
        end
        down_ = 1
    else
        c_d = (a_d-down_) - b_d
        down_ = 0
    end

    # 月数計算
    if a_m-down < b_m
        c_m = (12+a_m-down_) - b_m
        down_ = 1
    else
        c_m = (a_m-down_) - b_m
        down_ = 0
    end

    # 年数計算
    c_y = (a_y-down_) - b_y

    return c_y, c_m, c_d
end
=#
# サブネット内のサーバーアドレスの故障の中で同一期間のものを検出する関数
function suberr(er, fix, sub)
    suber = Dict()
    for (sb, s_ads) in sub
        fs = []
        for ad in s_ads
            if haskey(fix, ad)
                if isempty(fs)
                    fs = fix[ad] # 直った故障のリスト
                else
                    for fd in fix[ad] # 直った故障の中の一つ
                        # 既に格納されているサーバーの故障期間と被っている場合を考える
                        for f_ in fs
                            if !(parse(Int, fd[2]) < parse(Int, f_[1]) && parse(Int, fd[1]) > parse(Int, f_[2]))   
                                if !haskey(suber, sb)
                                    erterm = suberr_term(fd[1], fd[2], f_[1], f_[2])
                                    suber[sb] = [erterm]                                   
                                else
                                    erterm = suberr_term(fd[1], fd[2], f_[1], f_[2])
                                    lss = suber[sb]
                                    push!(lss, erterm)
                                    suber[sb] = lss 
                                end    
                            end
                        end

                        # 同一サブネット内の他のサーバーにおいて、故障の修復が確認できない場合
                        # 間に合わず
                        #=te1 = fd[1]
                        te2 = fd[2]
                        for e in keys(er)
                            if e in keys(sub)
                                if parse(Int, te1) < parse(Int, er[e][1]) 
                                    =#
                                     
                    end
                end
            end
        end
    end

    return suber
end

# suberはキーをサブネット、値を(故障確認日時, 修復確認日時, 連続故障回数)とする

# サブネットが故障していた期間を出力する関数
function suberr_term(sb1, sb2, sb3, sb4)
    sb1_1 = parse(Int, sb1)
    sb1_2 = parse(Int, sb2)
    sb2_1 = parse(Int, sb3)
    sb2_2 = parse(Int, sb4)

    if sb1_1 < sb2_1 && sb2_2 < sb1_2
        return [sb3, sb4]
    elseif sb2_1 <= sb1_1 && sb1_2 <= sb2_2
        return [sb1, sb2]
    elseif sb2_1 <= sb1_1 && sb2_2 <= sb1_2
        return [sb1, sb4]
    elseif sb1_1 <= sb2_1 && sb1_2 <= sb2_2
        return [sb3, sb2]
    end
end