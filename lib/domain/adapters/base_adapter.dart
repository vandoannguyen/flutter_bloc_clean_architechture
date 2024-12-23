abstract class BaseAdapter<ENTITY, MODEL> {
  MODEL entityToModel(ENTITY data);

  ENTITY modelToEntity(MODEL data);
}
