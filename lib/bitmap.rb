require "chunk"

class Bitmap
    attr_reader :width, :height

    MAX_CHUNK_HEIGHT = 255

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
      width_in_bytes = width / 8
      while row_start < height do
        printChunk(connection, row_start, width_in_bytes)
        row_start += MAX_CHUNK_HEIGHT
      end
    end

    private

    def printChunk(connection, row_start, width_in_bytes)
      chunk_height = getChunkHeight(row_start)
      bytes = getChunkBytes(chunk_height, width_in_bytes)

      printChunkBytes(bytes, chunk_height, connection, width_in_bytes)
    end

    def printChunkBytes(bytes, chunk_height, connection, width_in_bytes)
      connection.write_bytes(18, 42)
      connection.write_bytes(chunk_height, width_in_bytes)
      connection.write_bytes(*bytes)
    end

    def getChunkBytes(chunk_height, width_in_bytes)
      (0...(width_in_bytes * chunk_height)).map { @data.getbyte }
    end

    def getChunkHeight(row_start)
      ((height - row_start) > MAX_CHUNK_HEIGHT) ? MAX_CHUNK_HEIGHT : (height - row_start)
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
