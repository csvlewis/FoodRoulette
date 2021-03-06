# frozen_string_literal: true

class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  validates_presence_of :latitude
  validates_presence_of :longitude
end
