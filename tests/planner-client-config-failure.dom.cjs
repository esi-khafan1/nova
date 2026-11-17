// Missing browser configuration must show a recoverable message, not crash the page.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path'),{JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
(async()=>{
 const result=await esbuild.build({entryPoints:['components/dashboard/use-planner-working-copy.ts'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,external:['react','react/jsx-runtime'],plugins:[{name:'missing-config',setup(b){b.onResolve({filter:/^@\/lib\/supabase\/client$/},()=>({path:'client',namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},()=>({contents:'export function createClient(){throw Error("missing Supabase config")}',loader:'js'}));}}]});
 const filename=path.join(process.cwd(),'virtual-working-copy.cjs'),m=new Module(filename,module);m.filename=filename;m.paths=Module._nodeModulePaths(process.cwd());m._compile(result.outputFiles[0].text,filename);
 const context={studentId:'student',weekStart:'2030-01-01',planId:null};
 function Test(){const state=m.exports.usePlannerWorkingCopy({enabled:true,context,counselorId:'counselor',planStatus:null,value:{title:'',notes:'',items:[],routines:[],weekExtra:{}},onRestore(){},onPublished(){}});return React.createElement('div',null,`${state.phase}:${state.warning}`)}
 const root=createRoot(document.getElementById('root'));await act(async()=>root.render(React.createElement(Test)));
 assert.match(document.body.textContent,/error:دریافت اطلاعات یا پیش‌نویس انجام نشد/);
 await act(async()=>root.unmount());dom.window.close();console.log('PASS: missing browser config is handled without a white screen');
})().catch(error=>{console.error(error);process.exitCode=1;dom.window.close()});
