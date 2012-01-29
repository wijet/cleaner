module Cleaner
  # Provides helper methods for File object which is passed to conditions.
  # With this module we can write file.name insted of File.basename(file)
  #
  module FileExtension
    def name
      File.basename(path)
    end

    def path_without_ext
      File.join(File.dirname(path), name_without_ext)
    end

    def name_without_ext
      name.chomp(File.extname(name))
    end
  end
end
