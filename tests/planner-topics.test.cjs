// Edition-independent selection and suggestion logic with synthetic entries.
const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const out=await esbuild.build({entryPoints:['lib/planner-topics.ts'],bundle:true,platform:'node',format:'cjs',write:false});
 const mod={exports:{}};new Function('module','exports',out.outputFiles[0].text)(mod,mod.exports);
 const {suggestNextTopic,selectBankTopic}=mod.exports;
 const bank=['گفتار یک','گفتار دو','گفتار سه'].map((title,i)=>({id:`bio-${i}`,subject:'زیست',grade:12,chapter:'۱',title,pageStart:1+i*5,pageEnd:5+i*5,order:i}));
 const dest={studentId:'A',subject:'زیست',grade:12,chapter:'۱',date:'2026-11-10',order:1};
 const use=(extra={})=>({studentId:'A',subject:'زیست',grade:12,chapter:'۱',date:'2026-11-03',order:0,topicIds:['bio-0'],...extra});
 assert.equal(suggestNextTopic(bank,[],dest).id,'bio-0');
 assert.equal(suggestNextTopic(bank,[use()],dest).id,'bio-1','previous week continues');
 assert.equal(suggestNextTopic(bank,[use({topicIds:['bio-0','bio-1']})],dest).id,'bio-2');
 assert.equal(suggestNextTopic(bank,[use({topicIds:['bio-2']})],dest),null);
 assert.equal(suggestNextTopic(bank,[use({studentId:'B',topicIds:['bio-2']})],dest).id,'bio-0','different student ignored');
 assert.equal(suggestNextTopic(bank,[use({date:'2026-11-10',order:2,topicIds:['bio-1']})],dest).id,'bio-0','later same-day block ignored');
 assert.equal(suggestNextTopic(bank,[use({date:'2026-11-10',order:0,topicIds:['bio-1']}),use()],dest).id,'bio-2');
 assert.equal(suggestNextTopic(bank,[use({date:'2026-11-11'}),use({chapter:'۲'}),use({grade:11}),use({subject:'شیمی'})],dest).id,'bio-0');
 assert.equal(suggestNextTopic(bank,[use({topicIds:['missing']}),use()],dest).id,'bio-1','unknown removed entries do not break older history');
 assert.throws(()=>suggestNextTopic([...bank,bank[0]],[],dest),/Invalid topic bank/);
 assert.throws(()=>suggestNextTopic(bank,[],{...dest,date:'2026-02-30'}),/Invalid insertion/);
 const edited=selectBankTopic(bank[0],{start:1,end:7});assert.deepEqual(edited,{bankId:'bio-0',title:'گفتار یک',pageStart:1,pageEnd:7});assert.equal(bank[0].pageEnd,5);
 assert.deepEqual(selectBankTopic({...bank[0],pageStart:null,pageEnd:null}),{bankId:'bio-0',title:'گفتار یک',pageStart:null,pageEnd:null});
 for(const pages of [{start:0,end:3},{start:2,end:1},{start:null,end:4},{start:1.5,end:4}])assert.throws(()=>selectBankTopic(bank[0],pages),/Invalid topic page/);
 console.log('PASS: per-student chronological suggestions, multi-topic continuation and editable page ranges');
})().catch(e=>{console.error(e);process.exitCode=1});
