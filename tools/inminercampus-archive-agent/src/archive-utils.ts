export function classifyArchiveHash(
  expectedSha256: string,
  actualSha256: string,
): 'same' | 'conflict' {
  return expectedSha256 === actualSha256 ? 'same' : 'conflict'
}
