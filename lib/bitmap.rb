require "chunk"

class Bitmap
    attr_reader :width, :height

    def self.from_source source
      data = obtain_data source
      width = obtain_width data
      height = obtain_height data
      new(width, height, source)
    end

    def initialize(width, height, source)
        set_data(source)
        @width = width
        @height = height
    end

    def wider_than? width
      @width > width
    end

    def print connection
      row_start = 0

      while row_start < height do
        print_chunk_starting_from(connection, row_start)

        row_start += Chunk::MAX_HEIGHT
      end
    end

    private

    def print_chunk_starting_from(connection, row_start)
      chunk_height = getNextChunkHeight(row_start)
      chunk = Chunk.new(@width, chunk_height, @data)
      chunk.print connection
    end

    def getNextChunkHeight(row_start)
      ((height - row_start) > Chunk::MAX_HEIGHT) ? Chunk::MAX_HEIGHT : (height - row_start)
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
      tmp = data.getbyte
      height = (data.getbyte << 8) + tmp
      height
    end

    def self.obtain_width data
      tmp = data.getbyte
      width = (data.getbyte << 8) + tmp
      width
    end
  end
