describe Admin::User do
  describe "#authenticate" do
    context "when username or password blank" do
      it "returns nil" do
        user = described_class.authenticate(username: "", password: "")
        expect(user).to be(nil)
      end
    end

    context "when username does not match value in environment" do
      it "returns nil" do
        user = described_class.authenticate(username: "abc", password: "123")
        expect(user).to be(nil)
      end
    end

    context "when valid username and incorrect password" do
      it "returns nil" do
        user = described_class.authenticate(username: "username", password: "123")
        expect(user).to be(nil)
      end
    end

    context "when valid username and password" do
      it "returns the user" do
        user = described_class.authenticate(username: "username", password: "password")
        expect(user).to be_instance_of(described_class)
      end
    end
  end
end
