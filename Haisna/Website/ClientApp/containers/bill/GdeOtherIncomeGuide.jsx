import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import Table from '../../components/Table';

import { closeGdeOtherIncomeGuide } from '../../modules/bill/billModule';

const Wrapper = styled.div`
  height: 400px;
  margin-top: 10px;
  overflow-y: auto;
`;

const GdeOtherIncomeGuide = (props) => {
  const { otherlinediv, message, onSelected } = props;

  return (
    <GuideBase {...props} title="セット外請求明細の選択" usePagination >
      <MessageBanner messages={message} />
      <Wrapper>
        <Table triped hover>
          <thead>
            <tr>
              <td />
              <td style={{ width: 30 }} />
              <td style={{ width: 70 }}>金額</td>
              <td style={{ width: 30 }} />
              <td style={{ width: 70 }}>税額</td>
            </tr>
          </thead>
          <tbody>
            {otherlinediv && otherlinediv.map((item) => (
              <tr key={item.otherlinedivcd}>
                <td><a style={{ textDecoration: 'underline' }} role="presentation" onClick={() => (onSelected(item))}>{item.otherlinedivname}</a></td>
                <td />
                <td>&#165;{item.stdprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
                <td />
                <td>&#165;{item.stdtax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
              </tr>
            ))}
          </tbody>
        </Table>
      </Wrapper>
    </GuideBase>
  );
};

GdeOtherIncomeGuide.propTypes = {
  otherlinediv: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSelected: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  otherlinediv: state.app.bill.bill.gdeOtherIncomeGuide.otherlinediv,
  visible: state.app.bill.bill.gdeOtherIncomeGuide.visible,
  message: state.app.bill.bill.gdeOtherIncomeGuide.message,
});

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeGdeOtherIncomeGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(GdeOtherIncomeGuide);
