require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

module Downer
  describe DownloadWorker do
    let (:output) { double('output') }
    let (:urls) { DownloadStrategy::FlatFileStrategy.new(fixture_directory + "/some_images.txt").get_urls }
    
    describe '#start' do 
      it "should write a message to output when no urls exist to be downloaded" do
        output.should_receive(:puts).with("No URLs specified, exiting.")
        worker = DownloadWorker.new([], '/tmp', output)
        worker.start
      end
      
      it "should ignore arrays with nils" do
        output.should_receive(:puts).with("No URLs specified, exiting.")
        worker = DownloadWorker.new([nil,nil], '/tmp', output)
        worker.start
      end
      
      it "should create a download object for each url to be downloaded" do
        worker = DownloadWorker.new(urls, '/tmp', output)
        worker.items.size.should == urls.size
      end
      
      it "should write a message to output feed when a url cannot be downloaded" do
        bad_url = "http://www.urbaninfluence.com/will_never_succeed"
        worker = DownloadWorker.new([bad_url], '/tmp', output)
        output.should_receive(:puts).with("Could not download #{bad_url}, received http code 404")
        results = worker.start
        results.size.should == 0
      end
      
      it "should write a message to output feed when a url is successfully downloaded" do
        good_url = "http://www.urbaninfluence.com/sites/default/files/user_uploads/images/4th.png"
        worker = DownloadWorker.new([good_url], '/tmp', output)
        output.should_receive(:puts).with("Downloaded #{good_url}")
        results = worker.start
        results.size.should == 1
      end
    end
  end
end