/**
 * @file 受信状況ガイド
 */
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import styled from 'styled-components';
import moment from 'moment';

import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import Button from '../../components/control/Button';
import MessageBanner from '../../components/MessageBanner';

import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 170px;
  width: 450px;
`;

// レイアウト
const Section = styled.div`
`;
const ItemName = styled.div`
  display: inline-block;
  width: 105px;
`;
const ItemValue = styled.div`
  display: inline-block;
  width: 200px;
`;
const ItemButton = styled.div`
  display: inline-block;
`;

const mapStateToProps = (state) => ({
  guideState: state.app.reserve.consult.printStatusGuide,
});

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

// 表示処理
const PrintStatusGuide = (props) => {
  const { guideState, consultActions } = props;

  // ガイドを閉じる処理
  const handleClose = () => {
    // 画面を閉じる
    consultActions.closePrintStatusGuide();
  };

  // submit時の処理
  const handleSubmitContent = () => {
    // 印刷状況登録処理
    consultActions.registerPrintStatusRequest({
      data: guideState.data,
      callback: () => {
        // ガイドを閉じる
        handleClose();
      },
    });
  };

  const { cardprintdate, formprintdate } = guideState.data;

  return (
    <Modal
      caption="印刷状況"
      open={guideState.visible}
      onClose={() => handleClose()}
    >
      <Content>
        <MessageBanner messages={guideState.messages} />
        <Section>
          <ItemName>
            確認はがき出力
          </ItemName>
          <ItemValue>
            ：{cardprintdate ? moment(cardprintdate).format('YYYY/MM/DD hh:mm:ss') : '未出力'}
          </ItemValue>
          <ItemButton>
            <DialogActions>
              <Button value="クリア" onClick={() => consultActions.clearCardPrintDatePrintStatusGuide()} />
            </DialogActions>
          </ItemButton>
        </Section>
        <Section>
          <ItemName>
            一式書式出力
          </ItemName>
          <ItemValue>
            ：{formprintdate ? moment(formprintdate).format('YYYY/MM/DD hh:mm:ss') : '未出力'}
          </ItemValue>
          <ItemButton>
            <DialogActions>
              <Button value="クリア" onClick={() => consultActions.clearFormPrintDatePrintStatusGuide()} />
            </DialogActions>
          </ItemButton>
        </Section>
        <DialogActions>
          <Button
            value="確定"
            onClick={() => handleSubmitContent()}
          />
          <Button
            value="キャンセル"
            onClick={() => handleClose()}
          />
        </DialogActions>
      </Content>
    </Modal>
  );
};

PrintStatusGuide.propTypes = {
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
};

export default connect(mapStateToProps, mapDispatchToProps)(PrintStatusGuide);
