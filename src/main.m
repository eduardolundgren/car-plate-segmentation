img = imread('../assets/placa1.bmp');

[corners, imgGray, imgEdge] = findSegmentedCorners(img);
[rects] = findRectangles(corners);

nImgs = 2;
nRects = length(rects);
totalSubPlotRows = nRects + nImgs;
% disp(nRects)

if (nRects > 0)
	subplot(totalSubPlotRows, 1, 1), subimage(img)
	subplot(totalSubPlotRows, 1, 2), subimage(imgEdge)

	hold on
		for n = 1:1:nRects;
			p = rects{n};
			plot(p(1), p(2), '*g');
		end
	hold off

	for n = 1:3:nRects;
		p1 = rects{n};
		p2 = rects{n+1};
		p3 = rects{n+2};

		nImgs = nImgs + 1;
		imgCropped = imcrop(img, [p1(1), p1(2), abs(p1(1) - p2(1)), abs(p1(1) - p3(2))]);
		subplot(totalSubPlotRows, 1, nImgs), subimage(imgCropped)

		title(['Possible car plate segment (', num2str(nImgs-2), ')'])

		nImgs = nImgs + 1;
		imgCroppedBW = im2bw(imgCropped, 0.25);
		imgConnectedComponents = bwlabel(imgCroppedBW);

		stats = regionprops(imgConnectedComponents, 'BoundingBox', 'Solidity');
		boundingBox = cat(1, stats.BoundingBox);
		boundingBoxHeight = boundingBox(:, 4);
		numberIndexes = find((boundingBoxHeight >= 25) & (boundingBoxHeight <= 35));

		imgOutput = ismember(imgConnectedComponents, numberIndexes);
		subplot(totalSubPlotRows, 1, nImgs), subimage(imgOutput)
	end

else
	disp('Not found any car plate segment for this image.');
end