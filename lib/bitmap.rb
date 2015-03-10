require "chunk"

class Bitmap

    def self.from_source connection, source
      data = obtain_data source
      width = obtain_width data
      height = obtain_height data
      new(connection, width, height, source)
    end

    def initialize(connection, width, height, source)
        set_data(source)
        @width = width
        @height = height
        @connection =  connection
    end

    def wider_than? width
      @width > width
    end

    def print
      row_start = 0

      while row_start < @height do
        print_chunk_starting_from(@connection, row_start)

        row_start += Chunk::MAX_HEIGHT
      end
    end

    private

    def print_chunk_starting_from(connection, row_start)
      chunk_height = calculate_next_chunk_height(row_start)
      chunk = Chunk.new(@width, chunk_height, @data)
      chunk.print @connection
    end

    def calculate_next_chunk_height(row_start)
      ((@height - row_start) > Chunk::MAX_HEIGHT) ? Chunk::MAX_HEIGHT : (@height - row_start)
    end

    def set_data(source)
      @data = self.class.obtain_data source
    end

    def self.obtain_data source
      if source.respond_to?(:getbyte)
        data = source
      else
        data = StringIO.new(source.map(&:chr).join)
      end
      data
    end

    def self.obtain_height data
      obtain_parameter data
    end

    def self.obtain_width data
      obtain_parameter data
    end

    def self.obtain_parameter data
      tmp = data.getbyte
      (data.getbyte << 8) + tmp
    end
  end
