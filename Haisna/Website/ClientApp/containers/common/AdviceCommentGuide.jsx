import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import styled from 'styled-components';

import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';

import Modal from '../../components/Modal/Modal';
import Button from '../../components/control/Button';
import Checkbox from '../../components/control/CheckBox';

import { actions as judCmtStcActions } from '../../modules/preference/judCmtStcModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 600px;
  width: 700px;
`;

const AdviceCommentGuide = ({ open, onSelect, judClass, listItems, selected, actions }) => (
  <Modal
    caption="コメントの選択"
    open={open}
    onClose={() => actions.closeAdviceCommentGuide()}
  >
    <Content>
      <DialogContentText>
        {judClass.judclassname && `${judClass.judclassname}コメント`}
      </DialogContentText>
      <DialogActions>
        <Button
          value="確定"
          onClick={() => {
            // 判定コメント一覧から選択済みのレコードのみを抽出し、コールバックメソッドに返す
            const selectedItems = listItems.filter((rec) => selected.indexOf(rec.judcmtcd) >= 0);
            onSelect(selectedItems);
            // 画面を閉じる
            actions.closeAdviceCommentGuide();
          }}
        />
        <Button
          value="キャンセル"
          onClick={() => actions.closeAdviceCommentGuide()}
        />
      </DialogActions>
      <Table>
        <TableBody>
          {listItems.map((rec) => {
            const isSelected = (selected.indexOf(rec.judcmtcd) >= 0);
            return (
              <TableRow
                hover
                key={rec.judcmtcd}
                onClick={() => actions.selectAdviceCommentGuideItem({ judcmtcd: rec.judcmtcd })}
                selected={isSelected}
              >
                <TableCell padding="checkbox">
                  <Checkbox checked={isSelected} />
                </TableCell>
                <TableCell>
                  {rec.judcmtstc}
                </TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </Content>
  </Modal>
);

// propTypesの定義
AdviceCommentGuide.propTypes = {
  open: PropTypes.bool.isRequired,
  onSelect: PropTypes.func.isRequired,
  judClass: PropTypes.shape().isRequired,
  listItems: PropTypes.arrayOf(PropTypes.shape).isRequired,
  selected: PropTypes.arrayOf(PropTypes.string).isRequired,
  actions: PropTypes.shape().isRequired,
};

export default connect(
  (state) => ({
    judClass: state.app.preference.judCmtStc.adviceCommentGuide.judClass,
    listItems: state.app.preference.judCmtStc.adviceCommentGuide.listItems,
    open: state.app.preference.judCmtStc.adviceCommentGuide.open,
    selected: state.app.preference.judCmtStc.adviceCommentGuide.selected,
  }),
  (dispatch) => ({
    actions: bindActionCreators(judCmtStcActions, dispatch),
  }),
)(AdviceCommentGuide);
