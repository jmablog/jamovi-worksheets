import { copy } from 'https://deno.land/std/fs/copy.ts';

try {
	Deno.removeSync("_OUTPUT/index.docx");
	Deno.removeSync("_OUTPUT/index.pdf");

	// copy("00-Data-Files", "_WORKSHEETS/00-Data-Files", { overwrite: true });
	
} catch (err) {
	console.error(err)
}