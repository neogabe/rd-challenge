require 'rails_helper'

RSpec.describe AbandonedCartsJob, type: :job do
  it "marca carrinhos como abandonados após 3 horas" do
    cart = Cart.create(abandoned: false, updated_at: 4.hours.ago)
    AbandonedCartsJob.perform_now
    expect(cart.reload.abandoned).to be true
    expect(cart.abandoned_at).not_to be_nil
  end

  it "remove carrinhos abandonados há mais de 7 dias" do
    cart = Cart.create(abandoned: true, abandoned_at: 8.days.ago)
    AbandonedCartsJob.perform_now
    expect(Cart.find_by(id: cart.id)).to be_nil
  end
end