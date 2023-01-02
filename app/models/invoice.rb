class Invoice < ApplicationRecord
  validates :client_name, presence: true, uniqueness: true
  # FIXME: this should use `in: 0.01..999_999_99.99`, or :less_than, :greater_than combination
  validates :amount, presence: true, numericality: { in: 0.01..999_999_99.99 }

  def total
    if tax.present?
      amount * (1 + (tax / 100))
    else
      amount
    end
  end
end
