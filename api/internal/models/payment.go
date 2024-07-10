package models

import (
	"time"

	"github.com/google/uuid"
)

// Payment model
type Payment struct {
	Id          uuid.UUID `gorm:"type:uuid;default:uuid_generate_v4();primaryKey;column:id" json:"id"`
	Owner       string    `gorm:"column:owner" json:"owner"`
	Paid        bool      `gorm:"column:paid" json:"paid"`
	Amount      float64   `gorm:"column:amount" json:"amount"`
	Description string    `gorm:"column:description" json:"description"`
	CreatedAt   time.Time `gorm:"column:created_at" json:"created_at"`
	Callback    *string   `gorm:"column:callback" json:"callback"`
}

// Struct used to get new data for a payment
type PaymentInput struct {
	Owner       string  `json:"owner"`
	Amount      float64 `json:"amount"`
	Description string  `json:"description"`
	Callback    *string `json:"callback"`
}

// Returns a new Payment with the data from `in`
func NewPayment(in PaymentInput) Payment {
	return Payment{
		Id:          uuid.New(),
		Owner:       in.Owner,
		Paid:        false,
		Amount:      in.Amount,
		Description: in.Description,
		Callback:    in.Callback,
		CreatedAt:   time.Now(),
	}
}
