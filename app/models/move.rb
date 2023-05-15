class Move < ApplicationRecord
  belongs_to :piece
  enum color: ["white", "black"]
end
