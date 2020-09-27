import { createStore, applyMiddleware, combineReducers } from 'redux';
import { reducer as reduxFormReducer } from 'redux-form';
import logger from 'redux-logger';
import createSagaMiddleware from 'redux-saga';
import thunk from 'redux-thunk';

// Reducerのインポート
import reducer from './modules/reducer';

// Sagaのインポート
import rootSaga from './sagas/index';

// Store設定用の関数定義
const configureStore = () => {
  // Redux-FormのReducerを結合
  const allReducer = combineReducers({
    app: reducer,
    form: reduxFormReducer,
  });

  // Saga middlewareの作成
  const sagaMiddleware = createSagaMiddleware();

  // Storeの作成
  const store = createStore(
    allReducer,
    applyMiddleware(logger),
    applyMiddleware(thunk, sagaMiddleware),
  );

  // sagaの実行
  sagaMiddleware.run(rootSaga);

  // 作成されたStoreを返す
  return store;
};

export default configureStore;
