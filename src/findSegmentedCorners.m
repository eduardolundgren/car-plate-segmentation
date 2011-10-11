function [corners, imgGray, imgEdge] = findSegmentedCorners(img, blockSize, segmentThreshold)
	setDefaultValue(2, 'blockSize', 24);
	setDefaultValue(3, 'segmentThreshold', 5);

	halfBlockSize = floor(blockSize/2);
	imgGray = rgb2gray(img);
	imgEdge = edge(imgGray, 'canny');

	[rmax, cmax] = size(imgEdge);

	corners = {};

	for y = 1:rmax;
		for x = 1:cmax;
			centralPixel = imgEdge(y, x);

			xSegmentLeft = 0;
			xSegmentRight = 0;
			ySegmentBottom = 0;
			ySegmentTop = 0;

			for delta = 1:halfBlockSize;
				if ((x - delta) > 0)
					pixel = imgEdge(y, x - delta);
					xSegmentLeft = xSegmentLeft + 1;
					if (pixel == 0)
						xSegmentLeft = 0;
					end
				end

				if ((x + delta) < cmax)
					pixel = imgEdge(y, x + delta);
					xSegmentRight = xSegmentRight + 1;
					if (pixel == 0)
						xSegmentRight = 0;
					end
				end

				if ((y + delta) < rmax)
					pixel = imgEdge(y + delta, x);
					ySegmentBottom = ySegmentBottom + 1;
					if (pixel == 0)
						ySegmentBottom = 0;
					end
				end

				if ((y - delta) > 0)
					pixel = imgEdge(y - delta, x);
					ySegmentTop = ySegmentTop + 1;
					if (pixel == 0)
						ySegmentTop = 0;
					end
				end
			end

			if ((xSegmentRight >= segmentThreshold) && (ySegmentBottom >= segmentThreshold)) | ((xSegmentLeft >= segmentThreshold) && (ySegmentBottom >= segmentThreshold)) | ((xSegmentRight >= segmentThreshold) && (ySegmentTop >= segmentThreshold)) | ((xSegmentLeft >= segmentThreshold) && (ySegmentTop >= segmentThreshold))
				corners = [corners, [x y]];
			end

		end
	end