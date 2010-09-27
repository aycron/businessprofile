# Patch for attachment_fu to work on Windows

require 'tempfile'
class Tempfile
  def size
    if @tmpfile
      @tmpfile.fsync # added this line
      @tmpfile.flush
      @tmpfile.stat.size
    else
      0
    end
  end
end
