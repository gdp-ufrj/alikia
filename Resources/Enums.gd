extends Node

class_name Enums

enum CardTypes {
	ATAQUE,
	BARREIRA_ROCHOSA,
	LUFADA,
	NO_DAGUA,
	RAIO,
	TURBILHAO_CHAMAS
}

static func card_type_to_str(cardType : CardTypes):
	return CardTypes.keys()[cardType]
