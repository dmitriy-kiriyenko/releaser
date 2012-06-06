require 'spec_helper'

describe Releaser::Revision do
  let(:clazz) {Releaser::Revision}

  def extract_hash_from_revision(revision)
    {
      :major => revision.major,
      :minor => revision.minor,
      :codename => revision.codename,
      :build => revision.build,
      :sha => revision.sha
    }
  end

  def verify_revision(revision, expected_hash)
    extract_hash_from_revision(revision).should include(expected_hash)
  end

  context "creation" do
    context "from hash" do
      it "should create correct object from hash" do
        hash = {:major => 2, :minor => 3, :codename => "Hyperion", :build => 5, :sha => 'ab3de'}
        revision = clazz.new(hash)
        verify_revision(revision, hash)
      end

      it "should raise error when creating without major" do
        hash = {:minor => 3, :codename => "Hyperion", :build => 5, :sha => 'ab3de'}
        lambda { clazz.new(hash) }.should raise_error
      end
    end

    context "from string" do
      shared_examples_for "parsing from string" do
        it "should create correct object from string" do
          revision = clazz.new(given_string)
          verify_revision(revision, expected_hash)
        end
      end

      context "when only major" do
        let(:given_string) { "v6-Edison-59-gf7114dd" }
        let(:expected_hash) { {
          :major => 6,
          :minor => 0,
          :build => 59,
          :codename => "Edison",
          :sha => "gf7114dd"
        } }
        it_should_behave_like "parsing from string"
      end

      context "when major and minor" do
        let(:given_string) { "v6.1-Edison-59-gf7114dd" }
        let(:expected_hash) { {
          :major => 6,
          :minor => 1,
          :build => 59,
          :codename => "Edison",
          :sha => "gf7114dd"
        } }
        it_should_behave_like "parsing from string"
      end

    end

    context "serialization" do
      subject {clazz.new "v6.1-Edison-59-gf7114dd"}
      its(:to_s) { should == "v6.1.59 Edison" }
      its(:to_tagline) { should == "v6.1.59-Edison" }
      its(:to_deploy_tagline) { should == "v6.1.59" }

      context "with initial build" do
        subject {clazz.new "v6.1-Edison-0-gf7114dd"}
        its(:to_s) { should == "v6.1 Edison" }
        its(:to_tagline) { should == "v6.1-Edison" }
        its(:to_deploy_tagline) { should == "v6.1" }
      end

      context "without codename" do
        subject {clazz.new "v6.1-20-gf7114dd"}
        its(:to_s) { should == "v6.1.20" }
        its(:to_tagline) { should == "v6.1.20" }
        its(:to_deploy_tagline) { should == "v6.1.20" }
      end

      context "without codename and initial build" do
        subject {clazz.new "v6.1-0-gf7114dd"}
        its(:to_s) { should == "v6.1" }
        its(:to_tagline) { should == "v6.1" }
        its(:to_deploy_tagline) { should == "v6.1" }
      end
    end

    describe "current" do
      context "when build is initial" do
        subject {clazz.new "v6.1-Edison-0-gf7114dd"}
        it { should be_current }
      end

      context "when build is not initial" do
        subject {clazz.new "v6.1-Edison-59-gf7114dd"}
        it { should_not be_current }
      end
    end

    context "next version" do
      subject {clazz.new "v6.1-Edison-59-gf7114dd"}

      it "should correctly return next major version" do
        verify_revision(subject.next_major("Archimedes"), {
          :major => 7,
          :minor => 0,
          :build => 0,
          :codename => "Archimedes"
        })
      end

      it "should correctly return next major version without codename" do
        verify_revision(subject.next_major, {
          :major => 7,
          :minor => 0,
          :build => 0,
          :codename => nil
        })
      end

      it "should correctly return next minor version" do
        verify_revision(subject.next_minor, {
          :major => 6,
          :minor => 2,
          :build => 0,
          :codename => "Edison"
        })
      end
    end
  end
end
