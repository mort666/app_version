require 'active_support/core_ext/object'

require 'yaml'

#
# App::Version Namespace
#
module App
  #
  # Application Version main class
  #
  # @attr [String] major Major Version number
  # @attr [String] minor Minor Version number
  # @attr [String] patch Patch number
  # @attr [String] milestone Milestone information
  # @attr [String] build Build number
  # @attr [String] branch Git Branch information
  # @attr [String] meta Semantic version meta info
  # @attr [String] commiter Git Commiter information
  # @attr [String] build_date Build Date
  # @attr [String] format Format information
  #
  class Version
    include Comparable

    attr_accessor :major, :minor, :patch, :milestone, :build
    attr_accessor :branch, :meta, :committer, :build_date, :format

    [:major, :minor, :patch, :milestone, :build, :branch, :committer, :meta, :format].each do |attr|
      define_method "#{attr}=".to_sym do |value|
        instance_variable_set("@#{attr}".to_sym, value.blank? ? nil : value.to_s)
      end
    end


    # Creates a new instance of the Version class using information in the passed
    # Hash to construct the version number.
    #
    #   Version.new(:major => 1, :minor => 0) #=> "1.0"
    def initialize(args = nil)
      if args && args.is_a?(Hash)
        args.keys.reject { |key| key.is_a?(Symbol) }.each { |key| args[key.to_sym] = args.delete(key) }

        [:major, :minor].each do |param|
          fail ArgumentError.new("The #{param} parameter is required") if args[param].blank?
        end

        @major      = args[:major].to_s
        @minor      = args[:minor].to_s
        @patch      = args[:patch].to_s     unless args[:patch].blank?
        @meta       = args[:meta].to_s      unless args[:meta].blank?
        @milestone  = args[:milestone].to_s unless args[:milestone].blank?
        @build      = args[:build].to_s     unless args[:build].blank?
        @branch     = args[:branch].to_s    unless args[:branch].blank?
        @committer  = args[:committer].to_s unless args[:committer].blank?
        @format     = args[:format].to_s    unless args[:format].blank?

        unless args[:build_date].blank?
          b_date = case args[:build_date]
                   when 'git-revdate'
                     get_revdate_from_git
                   else
                     args[:build_date].to_s
                   end
          @build_date = Date.parse(b_date)
        end

        @build = case args[:build]
                 when 'svn'
                   get_build_from_subversion
                 when 'git-revcount'
                   get_revcount_from_git
                 when 'git-hash'
                   get_hash_from_git
                 when nil, ''
                   nil
                 else
                   args[:build].to_s
                 end
      end
    end

    # Parses a version string to create an instance of the Version class.
    #
    # @param version [String] Version Number String to parse and initialize object with
    # @raise [ArguementError] In the event string not parsable
    # @return [App:Version] Returns populated Version object
    def self.parse(version)
      m = version.match(/(\d+)\.(\d+)(?:\.(\d+))?(?:-([\w.\d]+))?(?:\sM(\d+))?(?:\s\((\d+)\))?(?:\sof\s(\w+))?(?:\sby\s(\w+))?(?:\son\s(\S+))?/)

      fail ArgumentError.new("The version '#{version}' is unparsable") if m.nil?

      version = App::Version.new major: m[1],
                                 minor: m[2],
                                 patch: m[3],
                                 meta: m[4],
                                 milestone: m[5],
                                 build: m[6],
                                 branch: m[7],
                                 committer: m[8]

      if m[9] && m[9] != ''
        date = Date.parse(m[9])
        version.build_date = date
      end

      version
    end

    # Loads the version information from a YAML file.
    #
    # @param path [String] Yaml file name to load
    def self.load(path)
      App::Version.new YAML.load(File.open(path))
    end

    #
    # Combined Compare operator for version
    #
    # @param other [App::Version] Version object to compare against
    # @return [Integer] returns -1 if (a <=> b)
    #
    def <=>(other)
      # if !self.build.nil? && !other.build.nil?
      #   return self.build <=> other.build
      # end

      %w(build major minor patch milestone branch meta committer build_date).each do |meth|
        rhs = send(meth) || -1
        lhs = other.send(meth) || -1

        ret = lhs <=> rhs
        return ret unless ret == 0
      end

      0
    end

    def sem_ver_format
      @@sem_ver_format =  "#{major}.#{minor}"
      @@sem_ver_format << ".#{patch}" unless patch.blank?
      @@sem_ver_format << "-#{meta}" unless meta.blank?
      @@sem_ver_format << "+#{build}" unless build.blank?
      @@sem_ver_format
    end

    #
    # Generate version string
    #
    # @return [String] Returns App Version string
    #
    def to_s
      if defined? @format
        str = eval(@format.to_s.inspect)
      else
        str = "#{major}.#{minor}"
        str << ".#{patch}" unless patch.blank?
        str << "-#{meta}" unless meta.blank?
        str << " M#{milestone}" unless milestone.blank?
        str << " (#{build})" unless build.blank?
        str << " of #{branch}" unless branch.blank?
        str << " by #{committer}" unless committer.blank?
        str << " on #{build_date}" unless build_date.blank?
      end
      str
    end

    private

    def get_build_from_subversion
      if File.exist?('.svn')
        # YAML.parse(`svn info`)['Revision'].value
        match = /(?:\d+:)?(\d+)M?S?/.match(`svnversion . -c`)
        match && match[1]
      end
    end

    def get_revcount_from_git
      `git rev-list --count HEAD`.strip if File.exist?('.git')
    end

    def get_revdate_from_git
      if File.exist?('.git')
        `git show --date=short --pretty=format:%cd|head -n1`.strip
      end
    end

    def get_hash_from_git
      if File.exist?('.git')
        `git show --pretty=format:%H|head -n1|cut -c 1-6`.strip
      end
    end
  end
end
