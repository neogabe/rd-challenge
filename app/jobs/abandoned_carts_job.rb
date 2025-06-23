class AbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    #marc como abandonados os carrinhos sem atualizacao ha mais de 3 horas e ainda nao marcados como abandonados
    Cart.where(abandoned: false)
    .where('updated_at < ?', 3.hours.ago)
    .find_each do |cart|
      cart.update(abandoned:true, abandoned_at: Time.current)
    end

    #remove carrinhos que estao abandonados ha mais de 7 dias
    Cart.where(abandoned: true)
    .where('abandoned_at < ?', 7.days.ago)
    .find_each do |cart|
      cart.destroy
    end
  end
end
