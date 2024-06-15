package dto

type LogDTO struct {
	ID       uint   `json:"id"`
	Method   string `json:"method"`
	Path     string `json:"path"`
	ClientIP string `json:"clientIp"`
	Date     string `json:"date"`
	Time     string `json:"time"`
	Level    string `json:"level"`
	Status   int    `json:"status"`
}
