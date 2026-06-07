function drawBackground(ctx, width, height) {
  const gradient = ctx.createLinearGradient(0, 0, 0, height);
  gradient.addColorStop(0, '#def3f7');
  gradient.addColorStop(0.89, '#eef6eb');
  gradient.addColorStop(0.92, '#c2a381');

  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, width, height);
}

function drawMaizePlant(ctx, xglobal, yglobal, height, tasselLength, girth) {
  const halfX = xglobal / 2;
  const baseY = yglobal;

  // ---------------- STALK ----------------
  function drawStalk() {
    const gr = girth / 3;
    const bottomY = baseY * 0.92;
    const topY = baseY - height;

    ctx.fillStyle = ctx.strokeStyle = '#30a630';
    ctx.lineWidth = 0.5;

    ctx.beginPath();
    ctx.moveTo(halfX - 1.5 * gr, bottomY);
    ctx.lineTo(halfX + 1.5 * gr, bottomY);
    ctx.lineTo(halfX + gr, topY);
    ctx.lineTo(halfX - gr, topY);
    ctx.fill();
    ctx.stroke();
  }

  // ---------------- LEAVES ----------------
  function drawLeaf(isRight, ylf) {
    const x = halfX;
    const y = ylf;

    const gradient = ctx.createLinearGradient(
      isRight ? x : x - 100,
      y - 100,
      x,
      y
    );
    gradient.addColorStop(0, '#309040');
    gradient.addColorStop(1, 'green');

    ctx.fillStyle = gradient;
    ctx.strokeStyle = 'darkgreen';
    ctx.lineWidth = 1;

    ctx.beginPath();
    ctx.moveTo(x, y);

    if (isRight) {
      ctx.bezierCurveTo(x, y - 10, x + 30, y - 35, x + 80, y - 35);
      ctx.quadraticCurveTo(x + 100, y - 35, x + 120, y - 25);
      ctx.bezierCurveTo(x + 65, y - 65, x + 45, y - 55, x + 10, y);
    } else {
      ctx.bezierCurveTo(x, y - 10, x - 30, y - 35, x - 80, y - 35);
      ctx.quadraticCurveTo(x - 100, y - 35, x - 120, y - 25);
      ctx.bezierCurveTo(x - 65, y - 65, x - 45, y - 55, x - 10, y);
    }

    ctx.fill();
    ctx.stroke();

    // Leaf vein
    ctx.strokeStyle = 'lightyellow';
    ctx.lineWidth = 0.5;

    ctx.beginPath();
    ctx.moveTo(x, y);

    if (isRight) {
      ctx.bezierCurveTo(x, y + 3, x + 50, y - 68, x + 110, y - 30);
    } else {
      ctx.bezierCurveTo(x, y + 3, x - 50, y - 68, x - 110, y - 30);
    }

    ctx.stroke();
  }

  // ---------------- CORN COB ----------------
  function drawCorn() {
    ctx.fillStyle = 'green';
    ctx.strokeStyle = 'darkgreen';
    ctx.lineWidth = 1;

    const x = xglobal;
    const y = yglobal - 0.66 * height;
    const index = 4 * girth - 0.5 * tasselLength - 0.02 * height;

    const radiusX = 15 + (height > 350 ? 0.3 : 0.1) * index;
    const radiusY = (height > 350 ? 50 : 25) + index;

    ctx.beginPath();
    ctx.ellipse(
      halfX + girth / 2 + 0.8 * radiusX,
      y,
      radiusX,
      radiusY,
      0.3,
      0,
      Math.PI * 2
    );
    ctx.fill();
    ctx.stroke();
  }

  // ---------------- TASSEL ----------------
  function drawTassels() {
    const x = halfX;
    const y = yglobal - height;

    const l = tasselLength < 30
      ? 30 + tasselLength
      : 60 + (tasselLength - 30) / 2;

    ctx.strokeStyle = 'goldenrod';
    ctx.lineWidth = 3.5;

    ctx.beginPath();

    // Lower branches
    ctx.moveTo(x + 1, y);
    ctx.bezierCurveTo(x + 1, y - l / 6, x + 10, y - l / 5, x + 25, y - l / 3);

    ctx.moveTo(x - 1, y);
    ctx.bezierCurveTo(x - 1, y - l / 6, x - 10, y - l / 5, x - 25, y - l / 3);

    // Middle branches
    ctx.moveTo(x + 1.5, y);
    ctx.bezierCurveTo(x + 1.5, y - l / 3, x + 10, y - l / 2, x + 20, y - 0.75 * l);

    ctx.moveTo(x - 1.5, y);
    ctx.bezierCurveTo(x - 1.5, y - l / 3, x - 10, y - l / 2, x - 20, y - 0.75 * l);

    // Upper branch
    ctx.moveTo(x, y);
    ctx.bezierCurveTo(x, y - l / 3, x + 2, y - (5 * l) / 6, x + 5, y - l);

    ctx.stroke();
  }

  // ---------------- ROOTS ----------------
  // This function draws the roots of the maize plant
    function drawRoots(ctx, xrt, yrt, girth) {
      let x = xrt/2;
      let y = 0.92*yrt;
      let rootlength = 10 + girth/4;
      ctx.strokeStyle = 'brown';
      ctx.lineWidth = 1+girth/8;
      ctx.beginPath();
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x+2*rootlength, y, x+3*rootlength, y+5);
      ctx.bezierCurveTo(x+3.5*rootlength, y+10, x+5*rootlength, y+8, x+6*rootlength, y+6);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x-2*rootlength, y, x-3*rootlength, y+5);
      ctx.bezierCurveTo(x-3.5*rootlength, y+10, x-5*rootlength, y+8, x-6*rootlength, y+6);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x+10, y, x+1.5*rootlength, y+10);
      ctx.bezierCurveTo(x+20, y+20, x+25, y+25, x+4*rootlength, y+25);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x-10, y, x-1.5*rootlength, y+10);
      ctx.bezierCurveTo(x-20, y+20, x-25, y+25, x-4*rootlength, y+25);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x+5, y, x+rootlength, y+10);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x-5, y, x-rootlength, y+10);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x+10, y, x+3*rootlength, y+15);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y, x-10, y, x-4*rootlength, y+15);
      ctx.moveTo(x, y);
      ctx.bezierCurveTo(x, y+5, x+5, y+15, x+5, y+35);
      ctx.moveTo(x, y);
      ctx.closePath();
      ctx.stroke();
      
    }

  // ---------------- DRAW ORDER ----------------
  drawTassels();
  drawCorn();

  const numLeaves = Math.floor((height - 100) / 30);
  let offset = 0;
  const topLeafY = yglobal - height + 50;

  for (let i = 1; i <= numLeaves; i += 2) {
    drawLeaf(true, topLeafY + offset);
    drawLeaf(false, topLeafY + offset + 30);
    offset += 60;
  }

  drawStalk();
  drawRoots(ctx, xglobal, yglobal, girth);
}

function drawMultipleMaizePlants(ctx, x, y, heightArray, tasselLengthArray, girthArray) {
  for (let i = 0; i < 5; i++) {
    ctx.font = '30px Arial';
    ctx.fillStyle = 'black';
    ctx.fillText(`Generation ${i * 5}`, x / 2 - 80, 50);

    drawMaizePlant(
      ctx,
      x,
      y,
      heightArray[i],
      tasselLengthArray[i],
      girthArray[i]
    );

    x += 600;
  }
}