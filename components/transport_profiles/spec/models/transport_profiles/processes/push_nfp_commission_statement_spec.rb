require "rails_helper"

module TransportProfiles
  describe Processes::PushNfpCommissionStatement, "provided a file and a gateway" do
    describe "with a local zip file" do
      let(:process) { instance_double(::TransportProfiles::Processes::Process) }
      let(:gateway) { ::TransportGateway::Gateway.new(nil, Rails.logger) }
      let(:local_zip_file_path) { URI.join("file://", URI.escape(File.join(File.dirname(__FILE__), "../../../test_data/commission_statements.zip"))) }
      let(:process_context) { ::TransportProfiles::ProcessContext.new(process) }

      #subject { ::TransportProfiles::Steps::UnzipFile.new(local_zip_file_path, :key_where_my_file_list_goes, :list_of_temp_dirs, gateway) }
      subject { Processes::PushNfpCommissionStatement.new(local_zip_file_path, gateway) }

      before :each do
        subject.execute(process_context)
      end

      it "should generate a list of the files it unzipped" do
        output_file_names = process_context.get(:statement_files)
        expect(output_file_names.size).to eq(2)
      end

      it "should create the temporary directory to unzip the files" do
        expect(process_context.get(:temp_dir)).not_to eq nil
      end

      it "should create the output files" do
        output_file_names = process_context.get(:statement_files)
        output_dir_name = process_context.get(:temp_dir).first
        unzipped_file_names = output_file_names.map do |f_name_uri|
          temp = URI.decode(f_name_uri.path.split(URI.encode(output_dir_name) + "/").last)
        end
      end

      it "has 2 steps" do
        expect(subject.steps.length).to eq 2
      end

      it "has 2 step_descriptions" do
        expect(subject.step_descriptions.length).to eq 2
      end

    end
  end
end
