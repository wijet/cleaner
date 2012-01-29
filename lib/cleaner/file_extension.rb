module Cleaner
  # Provides helper methods for File object which is passed to conditions.
  # With this module we can write file.name insted of File.basename(file)
  #
  module FileExtension
    def name
      File.basename(path)
    end

    def path_without_ext
      pathname = Pathname.new(path)
      pathname.sub_ext("").to_s
    end
  end
end
