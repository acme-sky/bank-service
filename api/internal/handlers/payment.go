package handlers

import (
	"net/http"
	"time"

	"github.com/acme-sky/acmebank-api/internal/models"
	"github.com/acme-sky/acmebank-api/pkg/db"
	"github.com/gin-gonic/gin"
)

// Handle POST request for `Payment` model.
// Validate JSON input by the request and crate a new payment. Finally returns
// the new created data.
// PostPayments godoc
//
//	@Summary	Create a new payment
//	@Schemes
//	@Description	Create a new payment
//	@Tags			Payments
//	@Accept			json
//	@Produce		json
//	@Success		201
//	@Router			/v1/payments/ [post]
func PaymentHandlerPost(c *gin.Context) {
	db, _ := db.GetDb()
	var input models.PaymentInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	payment := models.NewPayment(input)
	db.Create(&payment)

	c.JSON(http.StatusCreated, payment)
}

// Handle GET request for a selected id.
// Returns the payment or a 404 status
// GetPaymentById godoc
//
//	@Summary	Get an payment
//	@Schemes
//	@Description	Get an payment
//	@Tags			Payments
//	@Accept			json
//	@Produce		json
//	@Success		200
//	@Router			/v1/payments/{paymentId}/ [get]
func PaymentHandlerGetId(c *gin.Context) {
	db, _ := db.GetDb()
	var payment models.Payment
	if err := db.Where("id = ?", c.Param("id")).First(&payment).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, payment)
}

// Change a paid status to a payment.
// PayPaymentById godoc
//
//	@Summary	Pay a payment
//	@Schemes
//	@Description	Pay a payment
//	@Tags			Payments
//	@Accept			json
//	@Produce		json
//	@Success		200
//	@Router			/v1/payments/{paymentId}/ [put]
func PaymentHandlerPay(c *gin.Context) {
	db, _ := db.GetDb()
	var payment models.Payment
	if err := db.Where("id = ?", c.Param("id")).First(&payment).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
		return
	}

	payment.Paid = true
	if err := db.Save(&payment).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
		return
	}

	if payment.Callback != nil {
		req, err := http.NewRequest(http.MethodPost, *payment.Callback, nil)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
			payment.Paid = true
			if err := db.Save(&payment).Error; err != nil {
				c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
				return
			}
			return
		}

		httpClient := http.Client{
			Timeout: 30 * time.Second,
		}

		res, err := httpClient.Do(req)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
			payment.Paid = true
			if err := db.Save(&payment).Error; err != nil {
				c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
				return
			}
			return
		}

		if res.StatusCode != 200 {
			c.JSON(http.StatusNotFound, gin.H{"message": "return bad status"})
			return
		}

	}

	c.JSON(http.StatusOK, payment)
}
