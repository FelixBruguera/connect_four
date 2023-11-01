def make_edges(nodes, direction)
    edges_ver = []
    edges_hor = []
    edges_dia = []
    nodes.each do |i|
        vertical = []
        horizontal = []
        diagonal = []
        node = i.split('_')
        col = node[0].to_i
        row = @rows.index(node[1])
        horizontal.push("#{col+1}_#{@rows[row]}") unless col+1 > 6
        vertical.push("#{col}_#{@rows[row+1]}") unless row+1 > 6
        horizontal.push("#{col-1}_#{@rows[row]}") unless col-1 < 1
        vertical.push("#{col}_#{@rows[row-1]}") unless row-1 < 0
        diagonal.push("#{col+1}_#{@rows[row+1]}") unless col+1 > 6 || row+1 > 6
        diagonal.push("#{col+1}_#{@rows[row-1]}") unless row-1 < 0 || col+1 > 6
        diagonal.push("#{col-1}_#{@rows[row+1]}") unless col-1 < 1 || row+1 > 6
        diagonal.push("#{col-1}_#{@rows[row-1]}") unless row-1 < 0 || col-1 < 1
        edges_ver.push(vertical)
        edges_hor.push(horizontal)
        edges_dia.push(diagonal)
    end
    return edges_ver if direction == 'vertical'
    return edges_hor if direction == 'horizontal'
    edges_dia
end