export function createMarkerContent(color: string): HTMLDivElement {
  const div = document.createElement('div');
  div.style.width = '16px';
  div.style.height = '16px';
  div.style.borderRadius = '50%';
  div.style.backgroundColor = `${color}99`;
  div.style.border = `2px solid ${color}`;
  return div;
}
