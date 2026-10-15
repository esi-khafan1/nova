// Small CommonJS test runner for the repository's TypeScript assertion tests.
const fs=require('node:fs');const path=require('node:path');const ts=require('typescript');const Module=require('node:module');
const original=Module._resolveFilename;
Module._resolveFilename=function(request,parent,...rest){if(request.startsWith('@/'))request=path.join(__dirname,'..',request.slice(2));return original.call(this,request,parent,...rest);};
for(const ext of ['.ts','.tsx'])require.extensions[ext]=(module,filename)=>{const result=ts.transpileModule(fs.readFileSync(filename,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true},fileName:filename});module._compile(result.outputText,filename);};
require(path.resolve(process.argv[2]));
