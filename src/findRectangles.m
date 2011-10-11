function [rects] = findRectangles(corners, angleThreshold, minVerticalDistanceThreshold, maxVerticalDistanceThreshold, minHorizontalDistanceThreshold, maxHorizontalDistanceThreshold)
	setDefaultValue(2, 'angleThreshold', 1);
	setDefaultValue(3, 'minVerticalDistanceThreshold', 50);
	setDefaultValue(3, 'maxVerticalDistanceThreshold', 80);
	setDefaultValue(3, 'minHorizontalDistanceThreshold', 150);
	setDefaultValue(3, 'maxHorizontalDistanceThreshold', 200);

	rects = {};

	for row1 = 1:length(corners);
		p1 = corners{row1};
		x1 = p1(1);
		y1 = p1(2);

		rect = {[x1 y1]};

		horizontalFound = 0;
		verticalFound = 0;

		for row2 = 1:length(corners);
			p2 = corners{row2};
			x2 = p2(1);
			y2 = p2(2);

			rectLength = length(rect);

			if ((x1 == x2 && y1 == y2) && (rectLength == 3))
				% Do not compute the same point or if already found 3 possible points on the rectangle.
				continue;
			end

			ang = rad2deg(atan2(y2-y1, x2-x1));

			dist = norm(p2-p1);

			s1 = (ang <= (0 + angleThreshold)) && (ang >= (0 - angleThreshold)) && (dist >= minHorizontalDistanceThreshold) && (dist <= maxHorizontalDistanceThreshold);
			s2 = (ang <= (90 + angleThreshold)) && (ang >= (90 - angleThreshold)) && (dist >= minVerticalDistanceThreshold) && (dist <= maxVerticalDistanceThreshold);

			if (s1 && (horizontalFound == 0))
				horizontalFound = 1;
				rect = [rect, [x2 y2]];
			end

			if (s2 && (verticalFound == 0))
				verticalFound = 1;
				rect = [rect, [x2 y2]];
			end
		end

		if (length(rect) == 3)
			rects = [rects, rect];
		end
	end