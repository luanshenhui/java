// @flow

import * as React from 'react';
import classNames from 'classnames';

import Dialog from '@material-ui/core/Dialog';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogActions from '@material-ui/core/DialogActions';
import Button from '@material-ui/core/Button';

// タイプのインポート
import {
  type TableDiv,
  type SelectableItemClass,
  type SelectableRequestItem,
  type SelectableItem,
  type SelectableGroup,
  type SelectedValue,
} from '../../../types/common/itemAndGroupGuide';

// コンポーネントのインポート
import ModalContents from '../../control/ModalContents/ModalContents';
import ItemClassList from './ItemClassList';
import SelectableRequestItemList from './SelectableRequestItemList';
import SelectableItemList from './SelectableItemList';
import SelectableGroupList from './SelectableGroupList';
import SelectedItemList from './SelectedItemList';
import ListBox from '../../control/ListBox/ListBox';
import ListBoxHeader from '../../control/ListBox/ListBoxHeader';
import ListBoxItems from '../../control/ListBox/ListBoxItems';
import ListItem from '../../control/ListItem/ListItem';
import CircularProgress from '../../control/CircularProgress/CircularProgress';

// cssのインポート
import styles from './ItemAndGroupGuide.css';

// Propsの定義
type Props = {
  open: boolean,
  tableDiv: TableDiv,
  showItem?: boolean,
  showGroup?: boolean,
  classCd: ?string,
  itemClasses: Array<SelectableItemClass>,
  selectableRequestItems?: Array<SelectableRequestItem>,
  selectableItems?: Array<SelectableItem>,
  selectableGroups?: Array<SelectableGroup>,
  selectedValues: Array<SelectedValue>,
  onClickItemClass?: Function,
  onClickTableDiv?: Function,
  onChangeRequestItem?: Function,
  onChangeItem?: Function,
  onChangeGroup?: Function,
  onConfirm?: Function,
  onClose?: Function,
  isLoading?: boolean,
}

// コンポーネントの定義
const ItemAndGroupGuide = ({
  open,
  tableDiv,
  showItem,
  showGroup,
  classCd,
  itemClasses,
  selectableRequestItems,
  selectableItems,
  selectableGroups,
  selectedValues,
  onClickItemClass,
  onClickTableDiv,
  onChangeRequestItem,
  onChangeItem,
  onChangeGroup,
  onConfirm,
  onClose,
  isLoading,
}: Props) => (
  <Dialog maxWidth={false} open={open} onClose={onClose}>
    <DialogTitle>項目ガイド</DialogTitle>
    <ModalContents className={styles.contents}>
      <ListBox className={styles.itemClass}>
        <ListBoxHeader className={styles.header}>分野で検索</ListBoxHeader>
        <ListBoxItems className={classNames(styles.itemClass, styles.list)}>
          <ItemClassList itemClasses={itemClasses} classCd={classCd} onClick={onClickItemClass} />
        </ListBoxItems>
      </ListBox>
      <ListBox className={styles.selectableItem}>
        <ListBoxHeader className={styles.header}>
          {showItem && <ListItem className={tableDiv === 1 ? styles.selected : undefined} onClick={() => onClickTableDiv && onClickTableDiv(1)}>検査項目</ListItem>}
          {showGroup && <ListItem className={tableDiv === 2 ? styles.selected : undefined} onClick={() => onClickTableDiv && onClickTableDiv(2)}>グループ</ListItem>}
        </ListBoxHeader>
        <ListBoxItems className={classNames(styles.selectableItem, styles.list)}>
          {selectableRequestItems && <SelectableRequestItemList data={selectableRequestItems} onChange={onChangeRequestItem} />}
          {selectableItems && <SelectableItemList data={selectableItems} onChange={onChangeItem} />}
          {selectableGroups && <SelectableGroupList data={selectableGroups} onChange={onChangeGroup} />}
        </ListBoxItems>
      </ListBox>
      <ListBox className={styles.selectedItem}>
        <ListBoxHeader className={styles.header}>選択済みの項目</ListBoxHeader>
        <ListBoxItems className={classNames(styles.selectedItem, styles.list)}>
          <SelectedItemList selectedValues={selectedValues} />
        </ListBoxItems>
      </ListBox>
    </ModalContents>
    <DialogActions>
      <Button color="primary" onClick={onConfirm}>
        確定
      </Button>
      <Button color="primary" onClick={onClose}>
        キャンセル
      </Button>
    </DialogActions>
    {isLoading && <CircularProgress />}
  </Dialog>
);

// defaultPropsの定義
ItemAndGroupGuide.defaultProps = {
  showItem: true,
  showGroup: true,
  selectableRequestItems: undefined,
  selectableItems: undefined,
  selectableGroups: undefined,
  onClickItemClass: undefined,
  onClickTableDiv: undefined,
  onChangeRequestItem: undefined,
  onChangeItem: undefined,
  onChangeGroup: undefined,
  onConfirm: undefined,
  onClose: undefined,
  isLoading: false,
};

export default ItemAndGroupGuide;
