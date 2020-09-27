/**
 * @file 受診日一括変更(変更完了)
 */
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { Link } from 'react-router-dom';

import DialogContent from '@material-ui/core/DialogContent';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import MessageBanner from '../../components/MessageBanner';
import Table from '../../components/Table';

import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 450px;
  width: 600px;
`;

// レイアウト
const Section = styled.div`
  display: table;
`;

const mapStateToProps = (state) => ({
  guideState: state.app.reserve.consult.rsvCslListChangedDateGuide,
});

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

const RsvCslListChangedDateGuide = (props) => {
  const { guideState, consultActions } = props;
  const { params, data } = guideState;

  // ガイドクローズ
  const handleClose = () => {
    consultActions.closeRsvCslListChangedDateGuide();
    // 予約情報詳細画面の情報を読み直す
    consultActions.openReserveMainRequest();
  };

  return (
    <Modal
      caption="変更完了"
      open={guideState.visible}
      onClose={() => handleClose()}
    >
      <Content>
        <MessageBanner messages={guideState.messages} />
        {
          data && data.length > 0 && (
            <div>
              <Section>
                {`「${params.csldate}」に対して${data.length}名の受診日変更が行われました。`}
              </Section>
              <Section>
                <Table>
                  <thead>
                    <tr>
                      <th>受診コース</th>
                      <th>個人名称</th>
                      <th>団体名</th>
                      <th>検査オプション</th>
                      <th>時間枠</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.map((rec) => (
                      <tr key={`${rec.rsvno}`}>
                        <td><a href={`/contents/reserve/main/${rec.rsvno}`} target="_blank" rel="noreferrer noopener" >{rec.csname}</a></td>
                        <td>{rec.lastname}　{rec.firstname}</td>
                        <td>{rec.orgsname}</td>
                        <td>{rec.optname && rec.optname.replace(',', '、')}</td>
                        <td>{rec.rsvgrpname}</td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              </Section>
              <Link to={`/contents/reserve/main/${data[0].rsvno}`} onClick={() => handleClose()}>予約情報へ</Link>
            </div>
          )
        }
      </Content>
    </Modal>
  );
};

RsvCslListChangedDateGuide.propTypes = {
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
};

export default connect(mapStateToProps, mapDispatchToProps)(RsvCslListChangedDateGuide);
