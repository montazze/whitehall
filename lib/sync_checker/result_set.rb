module SyncChecker
  class ResultSet
    class NullCSV
      def self.<<(val); end
    end

    def initialize(progress_bar, csv_file_path = nil)
      @progress_bar = progress_bar

      if csv_file_path.present? && !Rails.env.test?
        file = File.open(File.expand_path(csv_file_path), "w")
        @csv = CSV.new(file)
      else
        @csv = NullCSV
      end
    end

    def <<(result)
      if result
        csv << result.to_row
        progress_bar.log result.to_s
      end

      progress_bar.increment
    end

    attr_reader :results, :progress_bar, :csv
    private :results, :progress_bar, :csv
  end
end