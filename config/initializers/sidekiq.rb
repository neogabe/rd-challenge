require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Abandoned carts job - every hour',
  cron: '0 * * * *',
  class: 'AbandonedCartsJob'
)