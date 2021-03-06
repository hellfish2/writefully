require 'spec_helper'

module Writefully
  describe Postable do 
    subject { ::Post.new } 

    describe "#klass_from" do 
      it "should return Writefully::Tag" do 
        subject.klass_from("tag").should eq "Writefully::Tag"
      end

      it "should turn Playlist" do 
        subject.klass_from("playlist").should eq "Playlist"
      end
    end

    it "should set published_at" do 
      subject.publish = true
      subject.publish_resource
      subject.published_at.should_not be_nil
    end

    it "should taxonomize correctly" do 
      subject.respond_to?(:playlists).should be_true
    end
  end
end