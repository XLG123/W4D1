class PolyTreeNode
  attr_reader :children, :value, :parent

  def initialize(value=nil)
    @parent = nil
    @children = []
    @value = value
  end

  def parent=(person)
    @parent.children.delete(self) if !@parent.nil?
    @parent = person
    if !@parent.nil? && !@parent.children.include?(self)
      @parent.children << self
    end
  end

  def add_child(child_node)
    @children << child_node if !@children.include?(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "Not a child!" if !@children.include?(child_node)
    @children.delete(child_node)
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if self.value == target_value
    @children.each do |child_node|
      result = child_node.dfs_tracked(target_value)
      return result if !result.nil?
    end
    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      first_node = queue.shift
      if first_node.value == target_value
        return first_node
      else
        queue += first_node.children
      end
    end
    nil
  end
  
end