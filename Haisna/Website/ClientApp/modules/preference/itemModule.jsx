import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const { showItemGuide, hideItemGuide } = createActions(
  // 検査項目ガイド表示制御アクション
  'SHOW_ITEM_GUIDE',
  'HIDE_ITEM_GUIDE',
);

const initialState = {
  guide: {
    show: false,
  },
};

export default handleActions({
  [showItemGuide]: (state) => (
    { ...state, guide: { show: true } }
  ),
  [hideItemGuide]: (state) => {
    const { guide } = initialState;
    return { ...state, guide };
  },
}, initialState);
