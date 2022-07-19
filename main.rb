class Node
    attr_accessor :value, :left_child, :right_child

    def initialize(value)
        @value = value
        @left_child = nil
        @right_child = nil
    end

    def value
        return @value
    end
end

class Tree
    attr_accessor :root, :list

    def initialize(array)
        @root = nil
        @list = array.sort
    end

    def root
        @root
    end

    def build_tree(start, last)
        if start > last
            return
        end

        mid = (start + last)/2

        root = Node.new(@list[mid])

        root.left_child = build_tree(start, mid - 1)
        root.right_child = build_tree(mid + 1, last)

        @root = root
    end

    def insert(value)
        complete = false
        new_node = Node.new(value)
        current_node = @root

        while complete == false
            if new_node.value < current_node.value && current_node.left_child.nil?
                current_node.left_child = new_node
                complete = true
            elsif new_node.value > current_node.value && current_node.right_child.nil?
                current_node.right_child = new_node
                complete = true
            elsif new_node.value < current_node.value
                current_node = current_node.left_child
            else
                current_node = current_node.right_child
            end
        end
    end

    def find_replacement(node)
        node = node.right_child

        while !node.left_child.nil?
            node = node.left_child
        end
        node
    end

    def delete(value)
        complete = false
        current_node = @root
        prev_node = @root

        while complete == false
            if current_node.value == value
                if current_node.left_child.nil? && current_node.right_child.nil?
                    current_node.value = nil
                    complete = true
                elsif !current_node.left_child.nil? && current_node.right_child.nil?
                    current_node = current_node.left_child
                    current_node.left_child = nil
                    complete = true
                elsif current_node.left_child.nil? && !current_node.right_child.nil?
                    current_node = current_node.right_child
                    current_node.right_child = nil
                    complete = true
                elsif !current_node.left_child.nil? && !current_node.right_child.nil?
                    replacement = find_replacement(current_node)
                    temp = replacement.value
                    delete(replacement.value)
                    current_node.value = temp
                    complete = true
                end
            elsif current_node.value < value
                prev_node = current_node
                current_node = current_node.right_child
            else
                prev_node = current_node
                current_node = current_node.left_child
            end
        end
    end

    def find(value)
        found = false
        current = @root

        while found == false
            if current.value == value
                found = true
            elsif current.value < value
                current = current.right_child
            else
                current = current.left_child
            end
        end
        current
    end

    def level_order()
        queue = []

        queue.append(@root)

        while !queue.empty? do
            node = queue[queue.length - 1]
            unless node.left_child.nil?
                queue.unshift(node.left_child)
            end

            unless node.right_child.nil?
                queue.unshift(node.right_child)
            end

            yield node
            queue.pop
        end
    end

    def inorder(node = @root, array = [])
        if node == nil
            return
        end

        inorder(node.left_child, array)
        array.append(node.value)
        inorder(node.right_child, array)
        array
    end

    def preorder(node = @root, array = [])
        if node == nil
            return
        end

        array.append(node.value)
        preorder(node.left_child, array)
        preorder(node.right_child, array)
        array
    end

    def postorder(node = @root, array = [])
        if node == nil
            return
        end

        postorder(node.left_child, array)
        postorder(node.right_child, array)
        array.append(node.value)
        array
    end

    def depth(value)
        found = false
        current = @root
        depth = 0

        while found == false
            if current.value == value
                found = true
            elsif current.value < value
                current = current.right_child
                depth+=1
            else
                current = current.left_child
                depth+=1
            end
        end
        depth
    end

    def root_index(list)
        mid = 0
        list.each_with_index do |item, index|
            if @root.value == item
                mid = index
            end
        end
        mid
    end

    def height(value)
        height = 0
        list = self.inorder
        highest_depth = 0
        value_depth = depth(value)
        mid = root_index(list)

        if value < @root.value
            list = list[0..mid-1]
        else
            list = list[mid+1..list.length-1]
        end

        list.each do |node|
            current = depth(node)
            if highest_depth < current
                highest_depth = current
            end
        end
        height = highest_depth - value_depth
        height
    end

    def balanced?
        list = self.inorder
        mid = root_index(list)

        left_tree = []
        right_tree = []
        x = 0

        while x < mid
            left_tree.append(list[x])
            x+=1
        end

        x = mid + 1
        while x  < list.length
            right_tree.append(list[x])
            x+=1
        end

        highest_left = 0
        left_tree.each do |item|
            current = self.height(item)
            if current > highest_left
                highest_left = current
            end
        end

        highest_right = 0
        right_tree.each do |item|
            current = self.height(item)
            if current > highest_right
                highest_right = current
            end
        end

        difference = highest_left - highest_right

        balance = false
        if difference == 1 || difference == 0 || difference == -1
            balance = true
        end
        balance
    end

    def rebalance
        list = self.inorder
        new_tree = Tree.new(list)
        new_tree.build_tree(0, list.length - 1)
        @root = new_tree.root
    end
end

array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
tree.build_tree(0, array.length-1)
p tree.balanced? #true
p tree.inorder #[3, 19, 19, 19, 29, 29, 35, 44, 53, 55, 65, 70, 90, 97, 98]
p tree.preorder #[44, 19, 19, 3, 19, 29, 29, 35, 70, 55, 53, 65, 97, 90, 98]
p tree.postorder #[3, 19, 19, 29, 35, 29, 19, 53, 65, 55, 90, 98, 97, 70, 44]
 tree.insert(2121)
 tree.insert(500000)
p tree.balanced? #false
tree.rebalance
p tree.balanced? #trie
p tree.inorder #[3, 19, 19, 19, 29, 29, 35, 44, 53, 55, 65, 70, 90, 97, 98, 2121, 500000]
p tree.preorder #[53, 19, 19, 3, 19, 29, 29, 35, 44, 90, 65, 55, 70, 98, 97, 2121, 500000]
p tree.postorder #[3, 19, 19, 29, 44, 35, 29, 19, 55, 70, 65, 97, 500000, 2121, 98, 90, 53]