import { plannerGridToItems, plannerItemsToGrid, type PlannerTopic } from './planner-grid';
import { plannerSnapshotFromEditor, type PlannerEditorBlock, type PlannerEditorGrid } from './planner-plan-adapter';
import type { PlanItem, PlanRoutine } from '../components/dashboard/weekly-plan-builder';
import { recommendedPublishers } from './recommended-publishers';
import { externalSimulationActivity, simulationProvider, simulationProviders } from './external-simulation';

/** Bridge the existing form and the durable editor representation. Opaque
 * extras and topic metadata survive editing; cloned blocks carry no identity. */
export function builderGrid(items:readonly PlanItem[]):PlannerEditorGrid {
 return plannerItemsToGrid(items.map((item):PlannerEditorBlock=>({
  ...item,examYear:item.examYear??null,extra:structuredClone(item.extra??null),
 })));
}
export function builderItems(grid:PlannerEditorGrid):PlanItem[] {
 return plannerGridToItems(grid).map(item=>({
  ...item,activityType:item.activityType as PlanItem['activityType'],
  sourceGrade:(item.sourceGrade??null) as PlanItem['sourceGrade'],
  preparationTrack:(item.preparationTrack??'konkur') as PlanItem['preparationTrack'],
  recommendedPublisher:item.recommendedPublisher??null,
  otherPublisher:Boolean(item.recommendedPublisher && !(recommendedPublishers as readonly string[]).includes(item.recommendedPublisher)),
  otherSimulationProvider:item.activityType===externalSimulationActivity && Boolean(simulationProvider(item.subject) && !(simulationProviders as readonly string[]).includes(simulationProvider(item.subject)!)),
 }));
}
export function builderSnapshot(input:{items:readonly PlanItem[];routines:PlanRoutine[];title:string;notes:string;weekStart:string;today:string;planStatus:'published'|'draft'|null;weekExtra:Record<string,unknown>}) {
 return plannerSnapshotFromEditor({...input,grid:builderGrid(input.items)});
}
export type BuilderTopic = PlannerTopic;
