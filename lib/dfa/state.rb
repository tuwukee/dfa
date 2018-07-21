module DFA
  class State
    attr_accessor :name,
                  :initial,
                  :edges

    def initialize(name, options = {})
      @name = name
      @initial = options[:initial] || false
      @edges = { outbound: [], inbound: [], self_referenced: [] }
    end

    def add_outbound(edge)
      edges[:outbound] << edge
    end

    def add_inbound(edge)
      edges[:inbound] << edge
    end

    def add_self_referenced(edge)
      edges[:self_referenced] << edge
    end

    def edges_count
      all_edges.count
    end

    def all_edges
      edges[:inbound] + edges[:outbound] + edges[:self_referenced]
    end

    def merge_edges!
      merge_self_referenced
      merge_outbound
    end

    def display_state
      puts '======'
      puts name
      puts "inbound: #{edges[:inbound].size}"
      puts edges[:inbound].map { |e| "#{e.start_state.name} -> #{e.value} -> #{name}" }.join(', ')
      puts "outbound: #{edges[:outbound].size}"
      puts edges[:outbound].map { |e| "#{name} -> #{e.value} -> #{e.end_state.name}" }.join(', ')
      puts "self_referenced: #{edges[:self_referenced].size}"
      puts edges[:self_referenced].map { |e| "#{name} -> #{e.value} -> #{name}" }.join(', ')
      puts '======'
    end

    private

    def merge_outbound
      groups = edges[:outbound].group_by { |edge| [edge.start_state.name, edge.end_state.name] }.values
      return if groups.all? { |group| group.size < 2 }

      self.edges[:outbound] = groups.map do |group|
        size = group.size
        if size > 1
          1.upto(size-1) do |i|
            group[0].value = "#{group[0].value}|#{group[i].value}"
          end
          [group[0]]
        else
          group
        end
      end.flatten
    end

    def merge_self_referenced
      size = edges[:self_referenced].count
      return if size < 2

      1.upto(size-1) do |i|
        edges[:self_referenced][0].value = "#{edges[:self_referenced][0].value}|#{edges[:self_referenced][i].value}"
      end

      self.edges[:self_referenced] = [edges[:self_referenced][0]]
    end
  end
end
