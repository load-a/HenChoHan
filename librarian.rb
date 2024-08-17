# frozen_string_literal: true

# A module adapted from the DragonRuby Tomes library.
#   Used to make requiring ruby files and their directories easier.
# @note This module only handles directories and '.rb' files.
module Librarian
  module_function

  # Calls Kernel#require on all .rb files in a given directory.
  # 	Files can be ignored via the ignore parameter or by including them in a folder with a dot in its name.
  # 	Ignores this file and 'main.rb' by default. (It assumes it is in the root directory).
  # This is the method you're most likely to use from this module.
  # @note This method 'requires' the files in each directory in alphabetical order. There is no easy way around this.
  # @param directory [String] The directory that contains the files to be required.
  # @param ignore [Array<String>] A list of all the files you want ignored.
  # 	The full file path (starting with './') must be specified.
  # @return [Void]
  def require_directory(directory = '.', ignore: %w[main.rb librarian.rb])
    dredge_directory(directory).reject { |file| ignore.include? file }
                               .each { |file| require file }
  end

  # Recursively gathers the file paths for all files in a given directory and its subdirectories.
  # @param directory [String] The directory name (relative to './') with no trailing forward-slash.
  # @param files [Array] This is the memo variable. Leave it empty if calling this method manually.
  # @return [Array<String>]
  def dredge_directory(directory = '.', files = [])
    header = "#{directory}/"

    files << list_file_paths(directory)
    folders = list_directories(directory)

    return files.flatten if folders.empty?

    folders.map do |folder|
      dredge_directory(header + folder, files.flatten)
    end.flatten.uniq
  end

  # Lists the full path for all Ruby (.rb) files in a given directory.
  # @param directory [String] The directory name with no trailing forward-slash.
  # @return [Array<String>]
  def list_file_paths(directory = '.')
    Dir.entries(directory).select { |file| file.include? '.rb' }
       .map { |file| "#{directory}/#{file}" }
       .flatten
  end

  # Lists any entries in a directory that lack a dot in its name. Does not list the root directory.
  # @param root_directory [String] The root directory name (no trailing forward-slash).
  # @return [Array<String>]
  def list_directories(root_directory = '.')
    Dir.entries(root_directory).reject { |file| file.include? '.' }.flatten
  end
end
