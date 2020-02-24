export const toBase64 = file =>
  new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.readAsDataURL(file);
    reader.onload = () => {
      const results = reader.result;
      // Firefox doesn't support negative lookbehinds so instead of
      // using a negative lookbehind to remove the required sections
      // of the file, simply split at the look behind.
      const [ result, content ] = results.split('base64,');

      return resolve({
        result: result,
        fileType: file.type,
        fileName: file.name,
        content: content
      });
    };
    reader.onerror = error => reject(error);
  });
