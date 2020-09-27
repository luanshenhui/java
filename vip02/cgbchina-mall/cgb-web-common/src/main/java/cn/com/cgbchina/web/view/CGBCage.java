package cn.com.cgbchina.web.view;

import com.github.cage.Cage;
import com.github.cage.image.ConstantColorGenerator;
import com.github.cage.image.EffectConfig;
import com.github.cage.image.Painter;
import com.github.cage.image.ScaleConfig;
import com.github.cage.token.RandomCharacterGeneratorFactory;
import com.github.cage.token.RandomTokenGenerator;

import java.awt.Color;
import java.util.Locale;
import java.util.Random;

/**
 * Created by 11140721050130 on 2016/5/25.
 */
public class CGBCage extends Cage {

	protected static final int HEIGHT = 80;

	protected static final int WIDTH = 290;

	protected static final char[] TOKEN_DEFAULT_CHARACTER_SET = (new String(
			RandomCharacterGeneratorFactory.DEFAULT_DEFAULT_CHARACTER_SET).replaceAll("b|f|i|j|l|m|o|t", "")
			+ new String(RandomCharacterGeneratorFactory.DEFAULT_DEFAULT_CHARACTER_SET).replaceAll("c|i|o", "")
					.toUpperCase(Locale.ENGLISH)
			+ new String(RandomCharacterGeneratorFactory.ARABIC_NUMERALS).replaceAll("0|1|9", "")).toCharArray();

	protected static final int TOKEN_LEN_MIN = 2;

	protected static final int TOKEN_LEN_DELTA = 2;

	public CGBCage() {
		this(new Random());
	}

	protected CGBCage(Random rnd) {
		super(new Painter(WIDTH, HEIGHT, null, null,
				new EffectConfig(true, true, true, false, new ScaleConfig(0.55f, 0.55f)), rnd), null,
				new ConstantColorGenerator(Color.BLACK), null, Cage.DEFAULT_COMPRESS_RATIO,
				new RandomTokenGenerator(rnd,
						new RandomCharacterGeneratorFactory(TOKEN_DEFAULT_CHARACTER_SET, null, rnd), TOKEN_LEN_MIN,
						TOKEN_LEN_DELTA),
				rnd);
	}
}
