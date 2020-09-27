// @flow

import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

// コンポーネントのインポート
import ItemAndGroupGuide from '../../components/common/ItemAndGroupGuide/ItemAndGroupGuide';

// Action Creator、Stateタイプ定義のインポート
import {
  actions as itemAndGroupGuideAction,
  type ItemAndGroupGuideState,
} from '../../modules/common/itemAndGroupGuideModule';

// Propsの定義
type Props = {
  itemAndGroupGuide: ItemAndGroupGuideState,
  actions: any,
}

// コンポーネントの定義
const ItemAndGroupGuideContainer = ({ itemAndGroupGuide, actions }: Props) => (
  <ItemAndGroupGuide
    {...itemAndGroupGuide}
    onClickItemClass={(classCd) => actions.itemAndGroupGuideSelectConditionRequest({ classCd })}
    onClickTableDiv={(tableDiv) => actions.itemAndGroupGuideSelectConditionRequest({ tableDiv })}
    onChangeRequestItem={(selectedValue, selectedIndex) => actions.itemAndGroupGuideSelectRequestItem({ selectedValue, selectedIndex })}
    onChangeItem={(selectedValue, selectedIndex) => actions.itemAndGroupGuideSelectItem({ selectedValue, selectedIndex })}
    onChangeGroup={(selectedValue, selectedIndex) => actions.itemAndGroupGuideSelectGroup({ selectedValue, selectedIndex })}
    onConfirm={() => actions.itemAndGroupGuideConfirm()}
    onClose={() => actions.itemAndGroupGuideClose()}
  />
);

// コンポーネントとstateとの接続
export default connect(
  (state) => ({
    itemAndGroupGuide: state.app.common.itemAndGroupGuide,
  }),
  (dispatch) => ({
    actions: bindActionCreators(itemAndGroupGuideAction, dispatch),
  }),
)(ItemAndGroupGuideContainer);
