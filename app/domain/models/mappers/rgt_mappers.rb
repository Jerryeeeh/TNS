# frozen_string_literal: true


module GoogleTrend
  module Gt
    class TrendMapper

      def initialize(name,config, gateway_class = Gt::RgtApi)
        @config = config
        @name = name
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@config, @name)
      end

      def find
        rgt = @gateway.jason
        build_entity(rgt)
      end

      def build_entity(rgt)
        DataMapper.new(rgt).build_entity
      end

      class DataMapper
        def initialize(rgt)
          @rgt = rgt
        end
        def build_entity
          GoogleTrend::Entity::RgtEntity.new(
            id: nil,
            query:,
            time_series:
          )
        end
        def query
          @rgt['search_parameters']['q']
        end
        def time_series
          l = []
          a = @rgt["interest_over_time"] #hash
          b = a["timeline_data"] #array
          b.each{ |data| l << "#{data["date"]} => #{data["values"][0]["value"]}"  }
          l.to_s
        end
      end
    end
  end
end

#print(GoogleTrend::Gt::TrendMapper.new('TSMC').find)
#print("\n") 
#print(GoogleTrend::Gt::TrendMapper.new('apple',"88fc96111ce19cfb3fa4eb149e1aa32df56db927da85503dcd16d2b37e711771").find.time_series)
#print("\n") 
#print(GoogleTrend::Gt::TrendMapper.new('TSMC').find.time_series)