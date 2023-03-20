using JLD2
include("findopt.jl")

function list_to_file(lst,file_name)
    open(file_name, "w") do f
        for elem in lst
            show(f, elem)
	    print(f, '\n')
	end
    end
end

function file_to_list(file_name)
    open(file_name, "r") do f
        [(Meta.parse(line) |> eval) for line in eachline(f) if line[begin] != '#']
    end
end

function tablesave(file_name, lst)
    save(file_name, "H", lst)
end

function tableload(file_name)
    global жtableж = load(file_name)["H"]
    global жKж = length(жtableж)-1
end
