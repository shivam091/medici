require "spec_helper"

RSpec.describe ServiceResponse do
  describe ".success" do
    subject { described_class.success(message: "Success message", payload: { key: "value" }) }

    it "returns a success ServiceResponse instance" do
      expect(subject.status).to eq(:success)
      expect(subject.message).to eq("Success message")
      expect(subject.payload).to eq({ key: "value" })
      expect(subject.http_status).to eq(:ok)
    end
  end

  describe ".error" do
    subject { described_class.error(message: "Error message", payload: { key: "value" }, http_status: :unprocessable_entity) }

    it "returns an error ServiceResponse instance" do
      expect(subject.status).to eq(:error)
      expect(subject.message).to eq("Error message")
      expect(subject.payload).to eq({ key: "value" })
      expect(subject.http_status).to eq(:unprocessable_entity)
    end
  end

  describe "#success?" do
    context "when status is :success" do
      subject { described_class.success }

      it "returns true" do
        expect(subject.success?).to be_truthy
      end
    end

    context "when status is not :success" do
      subject { described_class.error }

      it "returns false" do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe "#error?" do
    context "when status is :error" do
      subject { described_class.error }

      it "returns true" do
        expect(subject.error?).to be_truthy
      end
    end

    context "when status is not :error" do
      subject { described_class.success }

      it "returns false" do
        expect(subject.error?).to be_falsey
      end
    end
  end
end
