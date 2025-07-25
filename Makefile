# E2E tests.

main:  e2e_test

INPUT_ENC_S = texts/malaphor.txt
OUTPUT_END_S = texts
# EXPECTED =

# Echo ANSI color codes
# B = background, F = foreground
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
BLUE_B = \e[104m
RED_F = \e[91m
# Stop coloring from overflowing to other text.
END = \e[0m

e2e_test:
	@mix escript.build
	@make encode_decode_small_test

encode_decode_small_test:
	@./hman -e ${INPUT_ENC_S}
	@echo -e "${BLUE_B} System test diff: ${END}"
# @diff $(EXPECTED) $(OUTPUT) | xargs -I {} echo -e "${RED_F} {} ${END}"

# clean:
	# rm -f e2e_output
	# clear
	# @echo "Cleaned files"

.PHONY: main e2e_test encode_decode_small_test clean
